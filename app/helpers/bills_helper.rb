module BillsHelper

  def statement_item(arg)
    if arg.class == String
      arg
    else # date range
      output_html = ''
      output_html << 'from: '
      output_html << arg['from']
      output_html << ' to: '
      output_html << arg['to']
      output_html
    end
  end

  # TODO: finish me
  # need to have extra rows for table sections
  def nested_table(h)
    output_html = ''
    # output_html << h.inspect
    # something like

    hashes = []
    h.keys[0..-2].each do |k|
      hashes << h[k].collect{|x| {type: k}.merge x}
    end

    # output_html << hashes.inspect

    # output_html << '------ transformed hash ---------------'
    final_hash = {'shop' => hashes.flatten, 'total' => h['total']}

    # output_html << final_hash.to_s
    # output_html << '------ ***************** ---------------'
    output_html << flat_table(final_hash)
    output_html.html_safe
  end

  # convert hash containing one flat array to a table
  def flat_table(h)
    if h.keys.length == 2 && h.keys.last == 'total'
      data_name = h.keys.first
      # I do not know anything about the system so I use defensive programming
      data_keys = h[data_name].collect(&:keys).flatten.uniq

      content_tag(:table, border: 2) do
        concat table_head(data_keys)
        concat table_data(h)
        concat table_foot(h)
      end
    else
      raise 'unexpected table data'
    end
  end

  def table_head(data_keys)
    content_tag(:thead) do
      data_keys.collect{|x| content_tag(:td, x)}.join.html_safe
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
      output_html << content_tag(:td, h[k])
    end
    output_html.html_safe
  end

  def table_foot(h)
    content_tag(:tfoot) do
      content_tag(:tr) do
        concat content_tag(:td,'total', {class: :table_total, colspan: 2} )
        concat content_tag(:td, h['total']).html_safe
      end
    end
  end
end

# concat content_tag(:table) do
#   content_tag(:th,
#               data_keys.collect{|x| "<td>#{x}</td>\n"}.join)

# end
