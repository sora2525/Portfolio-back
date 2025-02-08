module AuthorizationSpecHelper
  def sign_in(user)
    post "/api/v1/auth/sign_in",
      params: { email: user.email, password: "password123" },
      as: :json

    puts "Sign-in Response Status: #{response.status}"
    puts "Sign-in Response Body: #{response.body}"
    puts "Sign-in Headers: #{response.headers}"

    raise "Sign-in failed! Status: #{response.status}, Body: #{response.body}" if response.status != 200

    response.headers.slice("client", "access-token", "uid")
  end
end
