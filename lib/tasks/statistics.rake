task :stats => "todolist:statsetup"
  
namespace :todolist do
  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES.insert(4, ["Exhibits", "app/exhibits"])
    ::STATS_DIRECTORIES.insert(5, ["Interactors", "app/interactors"])
    ::STATS_DIRECTORIES.insert(6, ["Policies", "app/policies"])
    ::STATS_DIRECTORIES.insert(7, ["Services", "app/services"])
    ::STATS_DIRECTORIES.insert(8, ["ViewModels", "app/view_models"])
  end
end