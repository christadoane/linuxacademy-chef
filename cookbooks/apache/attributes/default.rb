default["apache"]["sites"]["christa-doane-net3"] = { "site_title" => "Net3 website coming soon", "port" => 80, "domain" => "christa-doane-net3.mylabserver.com" }
default["apache"]["sites"]["christa-doane-net3b"] = { "site_title" => "Net3b website coming soon", "port" => 80, "domain" => "christa-doane-net3b.mylabserver.com" }
default["apache"]["sites"]["christa-doane-net1"] = { "site_title" => "Net1 website coming soon", "port" => 80, "domain" => "christa-doane-net1.mylabserver.com" }

case node["platform"]
when "centos"
	default["apache"]["package"] = "httpd"
when "ubuntu"
	default["apache"]["package"] = "apache2"
end
