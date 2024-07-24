Rails.configuration.to_prepare do
    class MyError < StandardError
    end

    class MyAuthenticationError < StandardError
    end
end