xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @channel.name
    xml.description @channel.name
    xml.link channel_view_url(:renders_with => @channel.slug)

    @articles.each do |article|
      xml << render(:partial => "templates/#{@render_as.slug}_item", :locals => {:article => article, :xml => xml})
    end
  end
end