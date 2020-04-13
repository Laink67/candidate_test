def find_id_by_login(login)
  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                         .users_full_info,
                                                  user_login: login)
  end
  @scenario_data.users_id[login]
end

def update_full_information
  full_info = $rest_wrap.get('/users')
  @scenario_data.users_full_info = full_info
end
