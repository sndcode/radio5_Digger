# frozen_string_literal: true

module Radio5
  class Client
    module Users
      def me
        # is it correct place for this?
      end

      def user
        # self - client
        # pass client to http to create request - take session_id - yes/no to add to headers
      end
    end
  end
end
