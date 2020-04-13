# Get 'li' with stable versions
def get_li
  find(:xpath, '/html/body/div[2]/div/div/div[1]/div/ul[2]/li[1]/ul').all('li').first
end

# get 'a' with last stable version
def get_a
  get_li.all('a').first
end

# get 'href' from 'a' with last stable version
def get_a_href
  get_a['href']
end
