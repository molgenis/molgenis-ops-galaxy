install.packages(c("DSMolgenisArmadillo", "DSI"))
install.packages("remotes")
library(remotes)
install_github("datashield/dsBaseClient", ref="6.1.0")

library(DSMolgenisArmadillo)
library(dsBaseClient)

builder <- DSI::newDSLoginBuilder()
builder$append(
  server = "local-default",
  url = "http://armadillo.local", # this is the armadillo datashield service
  user = "xxxxxx",
  password = "xxxxxx",
  driver = "ArmadilloDriver",
  table = "local/1_0_core_1_0/nonrep")
builder$append(
  server = "local-mediation",
  url = "http://armadillo.local", # this is the same armadillo datashield service, we pretend these are 2 separate servers
  user = "xxxxxx",
  password = "xxxxxx",
  driver = "ArmadilloDriver",
  table = "local/1_0_core_1_0/nonrep",
  profile = "mediation")

login_data <- builder$build()

conns <- DSI::datashield.login(logins = login_data, assign = FALSE)

datashield.assign(conns, "data", "local/1_0_core_1_0/nonrep")
datashield.tables(conns = conns)
datashield.profiles(conns = conns)
ds.ls(datasources = conns)
ds.colnames("data", datasources = conns)
ds.summary("data$agebirth_m_d", datasources = conns)

datashield.logout(conns)
