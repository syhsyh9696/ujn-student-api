module API
  class Test < Grape::API
    format :json

    after_validation do
      present :name, params[:name] if params[:name]
    end

    get '/greeting' do
      present :greeting, 'Hello!'
    end
  end
end
