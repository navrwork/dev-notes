# Microservices Notes

## Message Brokers
* [Kafka](https://kafka.apache.org/) - Apache Kafka is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.
	* Support mission-critical use cases with guaranteed ordering, zero message loss, and efficient exactly-once processing.
* [RabbitMQ](https://www.rabbitmq.com/) - RabbitMQ is a reliable and mature messaging and streaming broker, which is easy to deploy on cloud environments, on-premises, and on your local machine. It supports several open standard protocols, including AMQP 1.0 and MQTT 5.
	* Use cases: Decoupling interconnected services, RPC, Streaming, IoT
	* To monitor RabbitMQ, the combination of [Prometheus and Grafana](https://www.rabbitmq.com/docs/prometheus) is what team RabbitMQ would recommend to most users.
* Amazon SQS

### Kafka vs RabbitMQ
* [Rabbitmq-vs-apache-kafka | confluent.io](https://www.confluent.io/learn/rabbitmq-vs-apache-kafka/)

## REST API Clients
 * [Postman](https://www.postman.com/)
 * [httpie.io](https://httpie.io/app) 
 * [Advanced Rest Client | ARC](https://install.advancedrestclient.com/home)

 
## Tools
 * [Zipkin](https://zipkin.io/) is a tool that helps you troubleshoot latency problems in your service architecture by collecting and looking up timing data from your applications. 

