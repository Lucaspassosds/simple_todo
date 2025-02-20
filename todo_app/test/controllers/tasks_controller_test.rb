require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
    @task_params = {
      task: {
        title: "New Task",
        description: "This is a test task",
        completed: false
      }
    }
  end

  test "should get index of all tasks" do
    get tasks_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal Task.count, json_response.length
  end

  test "should show task" do
    get task_url(@task), as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @task.id, json_response['id']
    assert_equal @task.title, json_response['title']
  end

  test "should create task" do
    assert_difference('Task.count') do
      post tasks_url, params: @task_params, as: :json
    end

    assert_response :created
    
    json_response = JSON.parse(response.body)
    assert_equal @task_params[:task][:title], json_response['title']
  end
  
  test "should not create task with invalid params" do
    # Task without title should be invalid
    invalid_params = {
      task: {
        title: "",
        description: "Invalid task"
      }
    }
    
    assert_no_difference('Task.count') do
      post tasks_url, params: invalid_params, as: :json
    end

    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert json_response['errors'].present?
  end

  test "should update task" do
    patch task_url(@task), params: @task_params, as: :json
    assert_response :success
    
    @task.reload
    assert_equal @task_params[:task][:title], @task.title
  end
  
  test "should not update task with invalid params" do
    invalid_params = {
      task: {
        title: "",
        description: "Invalid update"
      }
    }
    
    patch task_url(@task), params: invalid_params, as: :json
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert json_response['errors'].present?
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete task_url(@task), as: :json
    end

    assert_response :no_content
  end
  
  test "should toggle task completion status" do
    original_status = @task.completed
    
    patch complete_task_url(@task), as: :json
    assert_response :success
    
    @task.reload
    assert_equal !original_status, @task.completed
    
    # Toggle back
    patch complete_task_url(@task), as: :json
    assert_response :success
    
    @task.reload
    assert_equal original_status, @task.completed
  end
  
  test "should handle non-existent task" do
    get task_url(999999), as: :json
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "Task not found", json_response["error"]
  end
end