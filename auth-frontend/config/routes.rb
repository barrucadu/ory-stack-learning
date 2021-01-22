Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope "/sign-in" do
    get  "/",     to: "sign_in#show", as: :sign_in
    post "/",     to: "sign_in#create"
    get  "/back", to: "sign_in#back", as: :sign_in_back
  end
end
