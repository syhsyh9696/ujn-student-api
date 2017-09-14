module API
  module Entities
    class Info < Grape::Entity
      expose :stu_num
      expose :stu_name
      expose :stu_gender
      expose :stu_id
      expose :stu_tel
    end

    class Error < Grape::Entity
      expose :code
      expose :message
    end

  end
end
