# Replace API_KEY and API_SECRET with the values you got from Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, "fdZsN3vTQkpkYIjGCDlYySuTK", "r2JdEwvOVjU8OzPdKi8vwC56wALKEF8O014vIcAY4WooivmJkvT"
  end