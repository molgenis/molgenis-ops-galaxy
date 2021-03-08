pipeline {
    agent {
        kubernetes {
            inheritsFrom 'ansible'
        }
    }
    stages {
        stage('Prepare [ build env ]') {
            steps {
                container('centos-8') {
                    sh 'yum install -y epel-release'
                    sh 'yum install -y ansible'
                }
            }
        }
        stage('Build [ pull request ]') {
            when {
                changeRequest()
            }
            steps {
                container('centos-8') {
                    dir(armadillo1) {
                        ansible-galaxy install -r requirements.yml
                        ansiblePlaybook(
                                inventory: 'inventory_ci.ini',
                                playbook: 'playbook.yml',
                                extras: '-e ci="true"'
                                )
                    }
                }

            }
        }
        stage('Build [ master ]') {
            when {
                branch 'master'
            }
            steps {
                milestone 1
                container('centos-8') {
                    dir(armadillo1) {
                        ansible-galaxy install -r requirements.yml
                        ansiblePlaybook(
                                inventory: 'inventory_ci.ini',
                                playbook: 'playbook.yml',
                                extras: '-e ci="true"'
                                )
                    }
                }
            }
        }
    }
}
