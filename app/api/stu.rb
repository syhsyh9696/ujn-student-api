module API
  class Stu < Grape::API
    version 'v1', using: :path # Define API::Version
    format :json

    helpers do
      def find_student stu_num
        stu_num = stu_num.to_s
        @student = Student.where("stu_num = ?", stu_num)
      end
    end


    namespace :student do
      params do
        requires :number, type: Integer
      end

      get '/:number' do
        # { :student => find_student(params[:number]) }
        info = find_student(params[:number])
        present info, with: API::Entities::Info
      end
    end

  end
end
