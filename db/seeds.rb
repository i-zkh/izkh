#encoding: utf-8
User.create(:email => 'test@iz.ru', :password => 'qwerty', :first_name =>'Test', :gender => 'm', :confirmed_at => '2014-03-17 20:33:14.151509', :city => 'Самара')

ServiceType.create!(:title => 'Водоснабжение')
ServiceType.create!(:title => 'Коммунальные услуги')
ServiceType.create!(:title => 'Интернет')

Vendor.create!(:title => "Test 1", service_type_id: 1, commission: 0)
Vendor.create!(:title => "Test 2", service_type_id: 2, commission: 0)
Vendor.create!(:title => "Test 3", service_type_id: 3, commission: 0)