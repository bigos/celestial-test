module BillsHelper
  # convert date range hash to string
  def date_range_hash(h)
    concat 'from: '
    concat h['from']
    concat ' to: '
    concat h['to']
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
      data_keys.collect{|x| "<td>#{x}</td>"}.join.html_safe
    end
  end

  def table_data(h)
    # duplicates from flat_table
    data_name = h.keys.first
    data_keys = h[data_name].collect(&:keys).flatten.uniq

    res = ''
    h[data_name].each do |r|
      res << content_tag(:tr, row_cells(r, data_keys))
    end
    res.html_safe
  end

  def row_cells(h, data_keys)
    res = ''
    data_keys.each do |k|
      res << content_tag(:td, h[k])
    end
    res.html_safe
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
