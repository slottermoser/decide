class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_and_belongs_to_many :participating_decisions, :join_table => "decisions_participants",
                          :class_name => 'Decision', :association_foreign_key => "decision_id"
  has_many :created_decisions, :class_name => "Decision"
  has_many :discussion_entries, :group => 'discussion_id'
  has_many :discussions_created
end
