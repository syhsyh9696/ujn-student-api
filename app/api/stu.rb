module API
  class Stu < Grape::API
    version 'v1', using: :path # Define API::Version
    format :json

    # Define grape-swagger
    add_swagger_documentation(
      mount_path: 'swagger_doc',
      hide_format: true,
      hide_documentation_path: true
    )


    helpers do
      def find_student stu_num
        stu_num = stu_num[1..-1] if stu_num.size == 12
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

      def find_major dept_num, major_num
        return [] if dept_num.size < 2
        return [] if major_num.size < 2

        dept_major = '____' + dept_num + major_num + '___'
        @student = Student.where("stu_num like ?", dept_major)
      end

      def format_stu_num stu_num
        return nil if stu_num.size < 11
        stu_num = stu_num[1..-1] if stu_num.size == 12

        @url = "http://iplat.ujn.edu.cn/photo/#{stu_num[0..3]}/#{stu_num}.jpg"
      end

      def find_num_with_name stu_name
        @student = Student.where("stu_name = ?", stu_name).first
        @student.stu_num
      end

      def find_dept_girls dept_num
        dept_num = '____' + dept_num + '_____'
        @dept_girls = Student.where("stu_num like ? AND stu_gender", dept_num, '女')
      end
    end

    namespace :student do
      get '/' do
        content_type 'text/plain'
        body "It's an API for UJN. "
      end

      params do
        requires :number, type: String
      end
      get '/num/:number' do
        # { :student => find_student(params[:number]) }
        info = find_student(params[:number])
        present info, with: API::Entities::Info
      end

      params do
        requires :grade, type: String
      end
      get '/grade/:grade' do
        info = find_grade(params[:grade])
        present info, with: API::Entities::Info
      end

      params do
        requires :name, type: String
      end
      get '/name/:name' do
        info = find_student_name(params[:name])
        present info, with: API::Entities::Info
      end

      namespace :dept do
        params do
          requires :dept_num, type: String
        end
        get '/:dept_num' do
          info = find_dept(params[:dept_num][0..1])
          present info, with: API::Entities::Info
        end

        params do
          requires :dept_num, type: String
          requires :dept_major, type: String
        end
        get '/:dept_num/:dept_major' do
          info = find_major(params[:dept_num][0..1], params[:dept_major][0..1])
          present info, with: API::Entities::Info
        end

        params do
          requires :dept_num, type: String
          # requires :dept_major, type: String
        end
        get '/girl/:dept_num' do
          info = find_dept_girls(params[:dept_num][0..1])
          present info, with: API::Entities::Info
        end

      end # Namespace :dept end

      namespace :pic do
        get '/url/:number' do
          { :pic => format_stu_num(params[:number]) }
        end

        get '/num/:number' do
          redirect format_stu_num(params[:number]), permanent: true
        end

        get '/name/:name' do
          stu_num = find_num_with_name(params[:name])
          redirect "../num/#{stu_num}"
        end

      end # Namespace :pic end

    end # Namsapce :student end

  end
end
