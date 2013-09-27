class DiscourseApi::Client < DiscourseApi::Resource

  def initialize(host, port=80, protocol='http')
    @host = host
    @port = port
    @protocol = protocol
  end

  post :topic_invite_user => "/t/:topic_id/invite", :require => [:email, :topic_id]
  post :post_create => "/posts", :require => [:raw]
  get :topics_latest => "/latest.json"
  get :topics_hot => "/hot.json"
  get :categories => "/categories.json"

  # updating a user (the :username argument will be taken from DiscourseApi::Client#api_username)
  put :update_user => "/users/:username.json", :require => [:username, :bio_raw, :name, :website]
  put :update_email => "/users/:username/preferences/email.json", :require => [:username, :email]
  put :update_username => "/users/:username/preferences/username.json", :require => [:username, :new_username]

end
