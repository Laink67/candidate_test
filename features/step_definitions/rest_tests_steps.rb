# frozen_string_literal: true

Given(/^получаю информацию о пользователях$/) do
  update_full_information
  $logger.info('Информация о пользователях получена')
end

When(/^реализовать шаг удаления пользователя по логину (\w+\.\w+)$/) do |login|
  id = find_id_by_login(login)

  response = $rest_wrap.delete('/users/' + id.to_s)
  $logger.info(response.inspect.to_s)

end

When(/^реализовать изменение параметров пользователя с логином (\w+\.\w+) на имя (\w+), фамилию (\w+), пароль ([\d\w@!#]+)$/) do |login, name, surname, password|
  id = find_id_by_login(login)

  response = $rest_wrap.put('/users/' + id.to_s, name: name, surname: surname, password: password)
  $logger.info("Изменение параметров пользователя - " + response.inspect.to_s)

end

When(/^реализовать добавление пользователя c логином (\w+\.\w+) именем (\w+) фамилией (\w+) паролем ([\d\w@!#]+), а затем его удаление$/) do
|login, name, surname, password|

  response_add = $rest_wrap.post('/users', login: login,
                                 name: name,
                                 surname: surname,
                                 password: password,
                                 active: 1)
  $logger.info("Добавление - " + response_add.inspect)
  update_full_information

  id = find_id_by_login(login)

  response_delete = $rest_wrap.delete('/users/' + id.to_s)

  $logger.info("Удаление только что добавленного пользователя " + response_delete.inspect)
end

When(/^реализовать удаление несуществующего пользователя по логину (\w+.\w+)$/) do |login|
  expect {
    raise id = find_id_by_login(login)
    response_delete = $rest_wrap.delete('/users/' + id.to_s)
  }.to raise_error(RuntimeError)

  $logger.info("При удалении несуществующего пользователя получена ошибка - RuntimeError")
end

When(/^реализовать редактирование несуществующего пользователя по логину (\w+.\w+) на имя (\w+), фамилию (\w+), пароль ([\d\w@!#]+)$/) do
|login, name, surname, password|
  expect {
    id = find_id_by_login(login)
    response_delete = $rest_wrap.delete('/users/' + id.to_s, name: name, surname: surname, password: password)
  }.to raise_error(RuntimeError)
  $logger.info("При изменении параметров несуществующего пользователя получена ошибка - RuntimeError")
end


When(/^добавление пользователя с незаполненными обязательными полями$/) do
  expect {
    response_add = $rest_wrap.post('/users')
  }.to raise_error(RuntimeError)
  $logger.info("При добавлении пользователя с незаполненными обязательными полями получена ошибка - RuntimeError")
end

When(/^получение несуществующего пользователя по (\d+)$/) do |id|
  expect {
    response = $rest_wrap.get('/users' + id.to_s)
  }.to raise_error(RuntimeError)
  $logger.info("При получении несуществующего пользователя получена ошибка - RuntimeError")
end

When(/^изменение данных пользователя (\w+.\w+) невалидными данными: имя (\d+)$/) do |login, name|
  expect {
    id = find_id_by_login(login)
    response = $rest_wrap.put('/users/' + id.to_s, name: name)
  }.to raise_error(RuntimeError)
  $logger.info("При изменени данных пользователя невалидными данными получена ошибка - RuntimeError")
end