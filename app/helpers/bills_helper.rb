module BillsHelper

  def statement_item(arg)
    if arg.class == String
      arg
    else # date range
      output_html = ''
      output_html << 'from:&nbsp;'
      output_html << arg['from']
      output_html << ' to:&nbsp;'
      output_html << arg['to']
      output_html.html_safe
    end
  end

  # it's not nested bu typed
  def nested_table(h)
    output_html = ''
    hashes = []
    h.keys[0..-2].each do |k|
      hashes << h[k].collect{|x| {type: k.underscore.gsub('_',' ')}.merge x}
    end
    final_hash = {'shop' => hashes.flatten, 'total' => h['total']}
    # after transforming the problem we can use flat table
    output_html << flat_table(final_hash)
    output_html.html_safe
  end

  # convert hash containing one flat array to a table
  def flat_table(h)
    if h.keys.length == 2 && h.keys.last == 'total'
      data_name = h.keys.first
      # I do not know anything about the system so I use defensive programming
      data_keys = h[data_name].collect(&:keys).flatten.uniq

      content_tag(:table, {class: ['table', 'table-striped', 'table-bordered', 'table-hover'] }) do
        concat table_head(data_keys)
        concat table_data(h)
        concat table_foot(h, data_keys)
      end
    else
      raise 'unexpected table data'
    end
  end

  def table_head(data_keys)
    content_tag(:thead, class: 'thead-inverse') do
      data_keys.collect{|x| content_tag(:th, x, class: (x == 'cost' ? 'cost' : nil))}.join.html_safe
    end
  end

  def table_data(h)
    # duplicates from flat_table
    data_name = h.keys.first
    data_keys = h[data_name].collect(&:keys).flatten.uniq

    output_html = ''
    h[data_name].each do |r|
      output_html << content_tag(:tr, row_cells(r, data_keys))
    end
    output_html.html_safe
  end

  def row_cells(h, data_keys)
    output_html = ''
    data_keys.each do |k|

      if k == 'cost'
        output_html << content_tag(:td, sprintf("%.2f",h[k]), class: k)
      else
        output_html << content_tag(:td, h[k])
      end
    end
    output_html.html_safe
  end

  def table_foot(h, data_keys)
    content_tag(:tfoot) do
      content_tag(:tr) do
        concat content_tag(:td,'total', {class: 'table-total', colspan: data_keys.length-1})
        concat content_tag(:td,sprintf('%.2f', h['total']), class: ['table-total', :cost]).html_safe
      end
    end
  end
end
