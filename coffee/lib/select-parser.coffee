class SelectParser

  constructor: (options) ->
    @options = options
    @options_index = 0
    @parsed = []
    @search_exclude_class = options.search_exclude_class or ''

  add_node: (child) ->
    if child.nodeName.toUpperCase() is "OPTGROUP"
      this.add_group child
    else
      this.add_option child

  add_group: (group) ->
    group_position = @parsed.length
    @parsed.push
      array_index: group_position
      group: true
      label: group.label
      children: 0
      disabled: group.disabled
    this.add_option( option, group_position, group.disabled ) for option in group.childNodes

  add_option: (option, group_position, group_disabled) ->
    if option.nodeName.toUpperCase() is "OPTION"
      if option.text != ""
        if group_position?
          @parsed[group_position].children += 1
        @parsed.push
          array_index: @parsed.length
          options_index: @options_index
          value: option.value
          text: option.text
          html: option.innerHTML
          selected: option.selected
          disabled: if group_disabled is true then group_disabled else option.disabled
          group_array_index: group_position
          classes: option.className
          style: option.style.cssText
          search_excluded: String(option.className).indexOf(@search_exclude_class) > -1 if @search_exclude_class
      else
        @parsed.push
          array_index: @parsed.length
          options_index: @options_index
          empty: true
      @options_index += 1

SelectParser.select_to_array = (select, options) ->
  parser = new SelectParser(options)
  parser.add_node( child ) for child in select.childNodes
  parser.parsed

this.SelectParser = SelectParser
