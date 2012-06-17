Template.tag_filter.tags = ->
  tag_infos = []
  total_count = 0
  Todos.find(list_id: Session.get("list_id")).forEach (todo) ->
    _.each todo.tags, (tag) ->
      tag_info = _.find(tag_infos, (x) ->
        x.tag is tag
      )
      unless tag_info
        tag_infos.push
          tag: tag
          count: 1
      else
        tag_info.count++

    total_count++

  tag_infos = _.sortBy(tag_infos, (x) ->
    x.tag
  )
  tag_infos.unshift
    tag: null
    count: total_count

  tag_infos

Template.tag_filter.tag_text = ->
  @tag or "All items"

Template.tag_filter.selected = ->
  (if Session.equals("tag_filter", @tag) then "selected" else "")

Template.tag_filter.events = "mousedown .tag": ->
  if Session.equals("tag_filter", @tag)
    Session.set "tag_filter", null
  else
    Session.set "tag_filter", @tag