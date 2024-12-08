class Chat < ApplicationRecord
    enum message_type: { user: 'user', character: 'character' }
end
