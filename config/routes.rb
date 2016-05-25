Rails.application.routes.draw do

  get 'visualizations/index'

  get 'viz/index'

  post 'viz/store_markup'

  post 'viz/del_markup'

  get 'viz/allCorpus'

  get 'viz/markupView'

  get 'viz/manualCatTool'

  get 'viz/timelineWithBrush'

  get 'viz/retrieve_session'

  #Markup Controller/View

  get 'markup/' => 'markup#index'

  post 'markup/store_markup' => 'markup#store_markup'

  post 'markup/del_markup' => 'markup#del_markup'

  post 'markup/update_markup' => 'markup#update_markup'

  get 'markup/manualCatTool' => 'markup#manualCatTool'

  get 'markup/display_kata' => 'markup#display_kata'

  get 'markup/index_simple' => 'markup#index_simple'

  get 'markup/timelineWithBrush' => 'markup#timelineWithBrush'

  get 'markup/retrieve_session' => 'markup#retrieve_session'

  get 'markup/markup_comparison' => 'markup#markup_comparison'

  get 'markup/display_AST_tree' => 'markup#display_AST_tree'

  get 'markup/:researcher' => 'markup#researcher'

  ### Mark Completed

  get 'completed/' => 'completed#index'

  post 'completed/update_completion' => 'completed#update_completion'

  get 'completed/timelineWithBrush' => 'markup#timelineWithBrush'

  get 'completed/mark_kata/' => 'completed#mark_kata'

  get 'completed/:kata' => 'completed#mark_completed'

  ###

  get 'cycle_catagorizer/cycle_catgories'

  get 'cycle_catagorizer/parseCSV'

  get 'cycle_catagorizer/listCC'

  get 'cycle_catagorizer/ListKatasInDojo'

  get 'cycle_catagorizer/ImportAllKatas'

  get 'cycle_catagorizer/buildCycleData'

  get 'cycle_catagorizer/ListAllCompiles'

  get 'cycle_catagorizer/InsertTestCompiles'

  get 'grader/index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
