


#create cluster en función del entorno que se esté desplegando

#resource "databricks_cluster" "sdgdatabrickscluster" {
#  cluster_name            = "cargameters"
#  idempotency_token       = "cargameters"
 # spark_version           = "7.0.x-scala2.12" 
#  driver_node_type_id     = "Standard_DS3_v2" 
 # node_type_id            = "Standard_DS3_v2" # any type will do here, just using the cheapest
 # num_workers             = 1
 # autotermination_minutes = 4
#}