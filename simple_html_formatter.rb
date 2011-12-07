require 'cucumber/formatter/html'
require 'features/support/formatter/system_capture'

class SimpleHTMLFormatter < Cucumber::Formatter::Html


  def initialize(step_mother, path_or_io, options)
    super(step_mother, path_or_io, options)
    @resource_id=0
  end


  def after_feature_element(feature_element)
    embed_html(SystemCapture.get_log_path($common_resource_name), "Log") if feature_element.instance_variable_get("@keyword").to_s.eql?("Scenario")
    super feature_element
  end


  def extra_failure_content(file_colon_line)
    @snippet_extractor ||= SnippetExtractor.new
    %{<pre class="ruby"><code>#{@snippet_extractor.snippet(file_colon_line)}</code></pre>
      #{html("#{SystemCapture.get_screenshot_path($common_resource_name)}", "Screenshot")}
    #{html("#{SystemCapture.get_html_path($common_resource_name)}", "Page source")}
    }
  end


  def after_table_row(table_row)
    super(table_row)
    if table_row.exception
      @builder.tr do
        @builder.td(:colspan => @col_index.to_s, :class => 'failed') do
          embed_html("#{SystemCapture.get_html_path($common_resource_name)}", "Page source")
          embed(SystemCapture.get_screenshot_path($common_resource_name), "image/png", "Screenshot")
        end
      end
    end
  end

  def print_table_row_messages
    super
    if  @outline_row && @outline_row !=0
      @builder.td do
        @builder << "<a href='#{SystemCapture.get_log_path($common_resource_name)}' target='_blank'> Log </a>"
      end
    end
  end


  def embed_html(src, label)
    id = "resource_#{@resource_id}"
    @resource_id += 1
    @builder.span(:class => 'embed') do |pre|
      pre << roll_element(id, src, label)
    end
  end

  def html(src, label)
    id = "iframe_#{@resource_id}"
    @resource_id += 1
    %{<span class="embed">#{roll_element(id, src, label)}</span>}
  end

  def roll_element(id, src, label)
    %{
    <a href="" onclick="iframe=document.getElementById('#{id}'); iframe.style.display = (iframe.style.display == 'none' ? 'block' : 'none');return false">
        #{label}</a> <iframe id="#{id}" style="display: none" src="#{src}" width="600px" height="600px" ></iframe>
    }
  end

end