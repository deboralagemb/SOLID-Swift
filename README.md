# SOLID-Swift

Seguindo o tutorial do site [raywenderlich.com](https://www.raywenderlich.com/21503974-solid-principles-for-ios-apps) para entender na prática o que significa cada um dos princípios de SOLID.

- **Single Responsibility**
> Uma classe deve ter um, e apenas um, motivo para mudar.

Cada classe ou tipo que definimos deve realizar apenas uma tarefa. Isso não significa que devemos implementar apenas um método, mas sim que cada classe deve ter um papel focado e especializado.


- **Open-Closed**
> Entidades de software, incluindo classes, módulos e funções, devem ser abertas para extensão mas fechadas para modificação.

Isso significa que devemos ser capazer de expandir as capacidades dos nossos tipos sem ter que alterar-los drásticamente para adicionar o que precisamos.


- **Liskov Substitution**
> Objetos num programa devem ser substituíveis com instâncias de seus subtipos sem alterar a corretude do programa.

Em outras palavras, se substituirmos um objeto por outro que é ua subclasse e essa alteração pode ocasionar na quebra da parte afetada, então não estamos seguindo esse princípio.

- **Interface Segregation**
> Clientes não devem ser forçados a depender de interfacees que não usam.

Ao modelar um protocolo que usaremos em diferetes partes do nosso código, é melhor quebrar esse protocolo em diversos pedaços pequenos onde cada um desse pedaço tem um papel específico. Dessa forma, clientes dependerão apenas da parte do protocolo que precisam.

- **Dependency Inversion**
> Dependa de abstrações, não de concretizações.

Diferentes partes do nosso código não devem depender de classes concretas. Elas não precisam desse conhecimento. Isso encoraja o uso de protocolos ao invés de usar classes concretas para conectar partes do nosso aplicativo.
