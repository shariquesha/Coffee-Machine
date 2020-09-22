class UserService
  def initialize
    @users = []
  end

  def create_user; end
  def remove_user; end
end


class User
  def initialize(user_id, name, email)
    @user_id = user_id
    @name = name
    @email = email
    @friends = {}
    @sent_friend_requests = {}
    @receive_friend_request = {}
    @private_chats = {}
    @group_chants = {}
  end
  def update; end
  def approve_friend_request; end
  def send_friend_request; end
  def receive_friend_request; end
  def reject_friend_request; end
  def message_user(user_id, message); end
  def message_group(group_id, message); end
end


class Chat
  def initialize(chat_id)
    @chat_id = chat_id
    @users = []
    @messages = []
  end

  def post_message(message)
    @messages << message  
  end
end


class PrivateChat < Chat 
  def intialize(user1, user2)
    super(self.object_id)
    self.users << user1
    self.users << user2
  end
end

class GroupChat < Chat
  def initialize
    super(self.object_id)
  end

  def add_user(user)
    self.users << user
  end

  def remove_user
    self.users.delete(user)
  end
end

class Message
  def initialize(message_id, user_id, message, timestamp)
    @message_id = message_id
    @user_id = user_id
    @message = message
    @timestamp = timestamp
  end
end


class FriendRequest
  def intialize(from_user_id, to_user_id, status, timestamp)
    @from_user_id = from_user_id
    @to_user_id = to_user_id
    @status = status
    @timestamp = timestamp
  end
end

module status
  ACCEPTED = 1
  REJECTED = 2
end