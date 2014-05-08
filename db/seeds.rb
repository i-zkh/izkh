#encoding: utf-8
User.create(:email => 'test@iz.ru', :password => 'qwerty', :first_name =>'Test', :gender => 'm', :confirmed_at => '2014-03-17 20:33:14.151509', :city => 'Самара')
ServiceType.create(:title => 'Вода')
ServiceType.create(:title => 'Огонь')
Vendor.create(service_type_id: 1, title: "Рулон")
Vendor.create(service_type_id: 2, title: "Вагон")
