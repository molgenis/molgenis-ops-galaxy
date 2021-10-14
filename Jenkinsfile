pipeline {
    agent {
        kubernetes {
            inheritFrom 'ansible'
        }
    }
    stages {
        stage('Retrieve build secrets') {
           steps {
                container('vault') {
                    script {
                        env.ANSIBLE_GALAXY_TOKEN = sh(script: 'vault read -field=value secret/ops/token/ansible', returnStdout: true)
                    }
                }
           }
        }
        stage('Check [ pull request ]') {
            when {
                changeRequest()
            }
            parallel {
                stage('MOLGENIS (8)') {
                    when {
                        changeset "molgenis8/**/*"
                    }
                    steps {
                        container('toolset') {
                            dir('molgenis8') {
                                script{
                                    sh 'ansible-lint --force-color roles/*/*/main.yml'
                                }
                            }
                        }
                    }
                }
                stage('MOLGENIS (9)') {
                    when {
                        changeset "molgenis9/**"
                    }
                    steps {
                        container('toolset') {
                            dir('molgenis9') {
                                script{
                                    sh 'ansible-lint --force-color roles/*/*/main.yml'
                                }
                            }
                        }
                    }
                }
                stage('Armadillo (1)') {
                    when {
                        changeset "armadillo1/**"
                    }
                    steps {
                        container('toolset') {
                            dir('armadillo1') {
                                script {
                                    sh 'ansible-lint --force-color roles/*/*/main.yml'
                                }
                            }
                        }
                    }
                } 
            }
        }
        stage('Publish [ main ]') {
            when {
                branch 'main'
            }
            parallel {
                stage('MOLGENIS (8)') {
                    when {
                        changeset "molgenis8/**"
                    }
                    steps {
                        container('toolset') {
                            dir('molgenis8') {
                                script {
                                    sh 'ansible-lint --force-color roles/*/*/main.yml'
                                    sh 'ansible-galaxy collection build'
                                    env.ARTIFACT = sh(script: 'ls *.gz', returnStdout: true)
                                    sh 'ansible-galaxy collection publish ${ARTIFACT} --token ${ANSIBLE_GALAXY_TOKEN}'
                                }
                            }
                        }
                    }
                }
                stage('MOLGENIS (9)') {
                    when {
                        changeset "molgenis9/**"
                    }
                    steps {
                        container('toolset') {
                            dir('molgenis9') {
                                script {
                                    sh 'ansible-lint --force-color roles/*/*/main.yml'
                                    sh 'ansible-galaxy collection build'
                                    env.ARTIFACT = sh(script: 'ls *.gz', returnStdout: true)
                                    sh 'ansible-galaxy collection publish ${ARTIFACT} --token ${ANSIBLE_GALAXY_TOKEN}'
                                }
                            }
                        }
                    }
                }
                stage('Armadillo (1)') {
                    when {
                        changeset "armadillo1/**"
                    }
                    steps {
                        container('toolset') {
                            dir('armadillo1') {
                                script {
                                    sh 'ansible-lint --force-color roles/*/*/main.yml'
                                    sh 'ansible-galaxy collection build'
                                    env.ARTIFACT = sh(script: 'ls *.gz', returnStdout: true)
                                    sh 'ansible-galaxy collection publish ${ARTIFACT} --token ${ANSIBLE_GALAXY_TOKEN}'
                                }
                            }
                        }
                    }
                } 
            }
        }
    }
}
