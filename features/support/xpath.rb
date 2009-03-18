require 'rexml/document'

def xml_node_values xml, xpath
  begin
    doc = REXML::Document.new(xml).root
    REXML::XPath.match(doc, xpath).map { |node| (node.respond_to?(:value) ? node.value : node.text) }
  rescue
    raise "No #{xpath} found in response body (#{xml})"
  end
end
