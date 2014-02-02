#
class myvagrant::java {
    include jdk7

    jdk7::install7{ 'jdk1.7.0_45':
        version              => '7u45' ,
        fullVersion          => 'jdk1.7.0_45',
        alternativesPriority => 18000,
        urandomJavaFix       => false,
        sourcePath           => '/tmp/jdk'
    }

    class { 'jdk7::urandomfix' :}
}

#EOF
