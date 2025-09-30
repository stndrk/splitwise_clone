# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get "/people/:id", to: "static#person_page", as: :person
  get "/dashboard", to: "static#dashboard", as: :dashboard
  get "/settlement/amount", to: "static#settlement_amount", as: :settlement_amount
  post "/settlement", to: "static#settlement_create", as: :settlement_create
  post "/group", to: "person#group_create", as: :group_create
  post "/expense", to: "person#expense_create", as: :expense_create
  get "/expense/:user_id", to: "person#expense_fetch", as: :expense_fetch

  root to: "static#dashboard"
end
