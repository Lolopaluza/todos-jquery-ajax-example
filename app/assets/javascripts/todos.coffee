# app/assets/javascripts/todos.coffee

$ ->
  $("input[type=checkbox]").bind 'change', toggleDone
  $("form").bind 'submit', submitTodo
  $("#clean-up").bind 'click', cleanUpDoneTodos

  updateCounters()

# Define all functions below

toggleDone = () ->
  checkbox = this
  $(checkbox).parent().toggleClass "completed"
  updateCounters()

  todoId = $(checkbox).parent().data('id')

  $.ajax({
    type: "PUT",
    url: "/todos/#{todoId}.json",
    data: JSON.stringify({
      todo: { completed: $(checkbox).parent().hasClass("completed") }
    }),
    contentType: "application/json",
    dataType: "json"})

updateCounters = () ->
  $("#total-count").html $(".todo").length
  $("#completed-count").html $(".completed").length
  todo_count = $(".todo").length - $(".completed").length
  $("#todo-count").html todo_count

nextTodoId = () ->
  $(".todo").length + 1

createTodo = (title) ->
  console.log title
  newTodo = { title: title, completed: false }

  $.ajax({
      type: "POST",
      url: "/todos.json",
      data: JSON.stringify({
          todo: newTodo
      }),
      contentType: "application/json",
      dataType: "json"})

      .done((data) ->
        checkboxId = data.id
        $("#todolist").append($("<li></li>")
          .addClass("todo")
          .append($('<input>')
            .attr 'type', 'checkbox'
            .attr 'id', checkboxId
            .attr 'data-id', data.id
            .attr 'name', "todo[#{data.id}]"
            .val 1
            .bind 'change', toggleDone
            ).append(
              document.createTextNode " "
              ).append($('<label></label>')
                .attr 'for', checkboxId
                .html data.title))

        updateCounters())

      .fail((error) ->
        $("#todo_title").val title
        error_messsage = error.responseJSON.title[0]
        showError(error_messsage)

        console.log(error))

submitTodo = (event) ->
  event.preventDefault()
  resetErrors
  createTodo $("#todo_title").val()
  $("#todo_title").val null
  updateCounters()

resetErrors = () ->
  $("#error_message").remove()
  $("#todo_title").removeClass "error"

showError = (error_message) ->
  $("#todo_title").addClass("error")
  error_elem = $("<small></small>")
    .attr 'id', 'error_message'
    .addClass 'error'
    .html error_message
    .appendTo('form .field')

cleanUpDoneTodos = (event) ->
  event.preventDefault()
  $.each $(".completed"), (index, listItem) ->
    $listItem = $(listItem)
    todoId = $(listItem).data('id')
    deleteTodo(todoId)
    $listItem.remove()

deleteTodo = (todoId) ->
  $.ajax({
    type: "DELETE",
    url: "/todos/#{todoId}.json"
    contentType: "application/json",
    dataType: "json"})

    .done(() ->
      updateCounters())
