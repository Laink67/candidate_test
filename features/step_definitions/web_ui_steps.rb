# frozen_string_literal: true

When(/^захожу на страницу "(.+?)"$/) do |url|
  visit url
  $logger.info("Страница #{url} открыта")
  sleep 1
end

When(/^перехожу на вкладку Скачать/) do
  find(:xpath, '/html/body/div[1]/div/div[1]/a[2]').click
  $logger.info("Переход на вкладку Скачать")
  sleep 1
end
When(/^скачиваю последний стабильный релиз/) do
  get_a.click
  $logger.info("Скачивание последнего стабильного релиза осуществлено")
  sleep 20
end

When(/^проверяю наличие файла в директории$/) do
  any_downloads = downloaded?
  $logger.info(any_downloads ? "Файл в находится нужной директории" : "Файл в нужной директории отсутствует")
  sleep 1
end

When(/^проверяю имя скачанного файла$/) do
  name_installer = get_a_href.split('/').last
  $logger.info(check_name(name_installer) ?
                   "Имя скачанного файла и файла-установщика совпадают: #{name_installer}" :
                   "Проверка не пройдена")
end