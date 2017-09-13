module API
  class Stu < Grape::API
    version 'v1', using: :path # Define API::Version
    format :json

    helpers do
      def find_student stu_num
        stu_num = stu_num.to_s
        @student = Student.where("stu_num = ?", stu_num)
      end

      def find_grade grade_num
        grade_num = grade_num.to_s + '_______'
        @grade_student = Student.where("stu_num like ?", grade_num)
      end

      def find_student_name stu_name
        @student = Student.where("stu_name = ?", stu_name)
      end

      def find_dept dept_num
        return [] if dept_num.size < 2
        dept_num = '____' + dept_num + '_____'
        @student = Student.where("stu_num like ?", dept_num)
      end

      def format_stu_num stu_num
        return nil if stu_num.size < 11
        stu_num = stu_num[1..-1] if stu_num.size == 12

        @url = "http://iplat.ujn.edu.cn/photo/#{stu_num[0..3]}/#{stu_num}.jpg"
      end
    end


    namespace :student do
      params do
        requires :number, type: Integer
        requires :grade, type: Integer
        requires :name, type: String
        requires :dept_num, type: String
        requires :dept_major, type: String
      end

      get '/' do
        content_type 'text/plain'
        body "It's an API for UJN. "
      end

      get '/num/:number' do
        # { :student => find_student(params[:number]) }
        info = find_student(params[:number])
        present info, with: API::Entities::Info
      end

      get '/grade/:grade' do
        info = find_grade(params[:grade])
        present info, with: API::Entities::Info
      end

      get '/name/:name' do
        info = find_student_name(params[:name])
        present info, with: API::Entities::Info
      end

      get '/dept/:dept_num' do
        info = find_dept(params[:dept_num][0..1])
        present info, with: API::Entities::Info
      end

      get '/dept/:dept_num/:dept_major' do
        info = find_dept(params[:dept_num][0..1] + params[:dept_major][0..1])
        present info, with: API::Entities::Info
      end

      get '/pic/:number' do
        { :pic => format_stu_num(params[:number]) }
      end

    end

  end
end
