class Constant
  class Log < ::Log
    def tag!(tags)
      tags << :constant
    end
  end
end
