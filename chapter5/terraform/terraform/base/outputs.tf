# output "cache_nodes" {
#   value = {
#     for k, cluster in aws_elasticache_cluster.wordpress : k => cluster.cache_nodes
#   }
# }
# output "mysql_admin_password" {
#   sensitive = true
#   value     = random_password.password.result
# }
