class UserNotification

  def self.change_pass(user)
    mandrill = Mandrill::API.new 'IVxMQVT5lIrZ1F-YoAvipw'

    message = {  
      :subject=> "Новый пароль на сервисе АйЖКХ ",  
      :from_name=> "Сервис АйЖКХ",  
      :text=>"Новый пароль на сервисе АйЖКХ",  
      :to=>[{  
          :email=> user.email,  
          :name=> user.first_name
      }],  
      :html=>
        "<html><h1>Уважаемый пользователь #{user.first_name}!</h1>
          <p>
            Просим в целях безопасного использования сервиса АйЖКХ изменить пароль. Для этого пройдите по ссылке ниже и следуйте дальнейшим инструкциям
          </p>
            <a href='http://izkh.ru/users/password/edit?reset_password_token=@token'>Поменять пароль</a>
          <p>
           C Уважением, команда АйЖКХ.
          </p>
        </html>",
      :from_email=>"out@izkh.ru"
    } 
    mandrill.messages.send message
  end
end