xml.instruct!

xml.photo   :id => @photo.taker_id,
            :url => @photo.url(request.host_with_port),
            :name => @photo.name

