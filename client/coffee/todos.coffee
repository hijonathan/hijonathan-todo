Template.todos.any_list_selected = ->
  not Session.equals("list_id", null)

Template.todos.events = {}
Template.todos.events[okcancel_events("#new-todo")] = make_okcancel_handler(ok: (text, evt) ->
  tag = Session.get("tag_filter")
  Todos.insert
    text: text
    list_id: Session.get("list_id")
    done: false
    timestamp: (new Date()).getTime()
    tags: (if tag then [ tag ] else [])

  evt.target.value = ""
)
Template.todos.todos = ->
  list_id = Session.get("list_id")
  return {}  unless list_id
  sel = list_id: list_id
  tag_filter = Session.get("tag_filter")
  sel.tags = tag_filter  if tag_filter
  Todos.find sel,
    sort:
      timestamp: 1

Template.todo_item.tag_objs = ->
  todo_id = @_id
  _.map @tags or [], (tag) ->
    todo_id: todo_id
    tag: tag

Template.todo_item.done_class = ->
  (if @done then "done" else "")

Template.todo_item.done_checkbox = ->
  (if @done then "checked=\"checked\"" else "")

Template.todo_item.editing = ->
  Session.equals "editing_itemname", @_id

Template.todo_item.adding_tag = ->
  Session.equals "editing_addtag", @_id

Template.todo_item.events =
  "click .check": ->
    Todos.update @_id,
      $set:
        done: not @done

  "click .destroy": ->
    Todos.remove @_id

  "click .addtag": (evt) ->
    Session.set "editing_addtag", @_id
    Meteor.flush()
    focus_field_by_id "edittag-input"

  "dblclick .display .todo-text": (evt) ->
    Session.set "editing_itemname", @_id
    Meteor.flush()
    focus_field_by_id "todo-input"

  "click .remove": (evt) ->
    tag = @tag
    id = @todo_id
    evt.target.parentNode.style.opacity = 0
    Meteor.setTimeout (->
      Todos.update
        _id: id
      ,
        $pull:
          tags: tag
    ), 300

Template.todo_item.events[okcancel_events("#todo-input")] = make_okcancel_handler(
  ok: (value) ->
    Todos.update @_id,
      $set:
        text: value

    Session.set "editing_itemname", null

  cancel: ->
    Session.set "editing_itemname", null
)
Template.todo_item.events[okcancel_events("#edittag-input")] = make_okcancel_handler(
  ok: (value) ->
    Todos.update @_id,
      $addToSet:
        tags: value

    Session.set "editing_addtag", null

  cancel: ->
    Session.set "editing_addtag", null
)