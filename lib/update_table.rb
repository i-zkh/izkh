#encoding: utf-8
class UpdateTable

  def self.vendors
    parser("Vendor").each do |vendor|
      Vendor.create!(
        id:                   vendor['id'],
        title:                vendor['title'],
        service_type_id:      vendor['service_type_id'],
        commission:           vendor['commission'],
        created_at:           vendor['created_at'],
        updated_at:           vendor['updated_at'],
        commission_yandex:    vendor['commission_yandex'],
        commission_web_money: vendor['commission_webmoney']
      )
    end
  end

  def self.users
    parser("User").each do |user|
      User.create(
        id:                     user['id'],     
        email:                  user['email'],     
        password:               user['encrypted_password'],
        reset_password_token:   user['reset_password_token'],
        reset_password_sent_at: user['reset_password_sent_at'],
        remember_created_at:    user['remember_created_at'],
        sign_in_count:          user['sign_in_count'], 
        current_sign_in_at:     user['current_sign_in_at'],
        last_sign_in_at:        user['last_sign_in_at'],
        current_sign_in_ip:     user['current_sign_in_ip'],
        last_sign_in_ip:        user['last_sign_in_ip'],
        created_at:             user['created_at'],
        updated_at:             user['updated_at'],
        first_name:             user['first_name'],
        phone:                  user['phone_number'],
        admin:                  user['admin'].nil? ? false : user['admin'],
        confirmed_at:           "2014-03-17 20:33:14.151509",
        authentication_token:   user['authentication_token']
      ).encrypted_password
    end
  end

  def self.places
    place_type = ["Квартира", "Дом", "Квартира", "Гараж", "Дача"]
    parser("Place").each do |place|
      count = 1
      title = if Place.where(user_id: place['user_id'], title: place['title'] + " " + count.to_s) != []
                  while Place.where(user_id: place['user_id'], title: place['title'] + " " + count.to_s) != []
                    count += 1
                  end
                  title = place['title'] + " " + count.to_s
              elsif Place.where(user_id: place['user_id'], title: place['title']) != []
                  place['title'] + " " + count.to_s
              else
                place['title']
              end

        Place.create!(   
          id:         place['id'],
          user_id:    place['user_id'],
          title:      title,
          city:       place['city'],
          address:    place['street'] == "" ? "укажите адресс" : place['street'],
          building:   place['building'],
          apartment:  place['apartment'],
          created_at: place['created_at'],
          updated_at: place['updated_at'],
          place_type: place['type_id'] ? place_type[place['type_id']] : "Квартира"
        ) if !place['user_id'].nil? && !place['title'].nil? && place['title'].gsub(" ", "") != ""

    end
  end

  def self.services
    parser("Service").each do |service|
        count = 1
        title = if Service.where(user_id: service['user_id'], title: service['title'] + " " + count.to_s) != []
                    while Service.where(user_id: service['user_id'], title: service['title'] + " " + count.to_s) != []
                      count += 1
                    end
                    title = service['title'] + " " + count.to_s
                elsif Service.where(user_id: service['user_id'], title: service['title']) != []
                    service['title'] + " " + count.to_s
                elsif service['title'] == ""
                    "Объект"
                else
                  service['title']
                end

      Service.create!(
          id:              service['id'],
          title:           title,
          vendor_id:       service['vendor_id'],
          service_type_id: service['service_type_id'],
          user_account:    service['user_account'],
          place_id:        service['place_id'],
          user_id:         service['user_id'],
          created_at:      service['created_at'],
          updated_at:      service['updated_at']
      ) if !service['vendor_id'].nil? && !service['user_id'].nil? && !service['place_id'].nil? && !service['user_account'].nil? && service['user_account'].gsub(" ", "") != "" && !service['service_type_id'].nil?  
    end
  end

  def self.service_types
    parser("ServiceType").each do |service_type|
      ServiceType.create!(
        id:         service_type['id'],
        title:      service_type['title'],
        created_at: service_type['created_at'],
        updated_at: service_type['updated_at']
      )
    end
  end

  def self.tariff_templates
    parser("TariffTemplate").each do |tariff_template|
      TariffTemplate.create!(
        id:               tariff_template['id'],
        title:            tariff_template['title'],
        service_type_id:  tariff_template['service_type_id'],
        vendor_id:        tariff_template['vendor_id'],
        created_at:       tariff_template['created_at'],
        updated_at:       tariff_template['updated_at']
      )
    end
  end

  def self.parser(table)
    response = HTTParty.get( "http://izkh.ru/api/1.0/move?table=#{table}&auth_token=qTp9vacrKujvCLqQpAQx")
    response.parsed_response
  end
end