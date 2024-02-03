> # Домашнее задание к занятию «Микросервисы: масштабирование»

# Q/A

> Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры. Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: Кластеризация

> Предложите решение для обеспечения развёртывания, запуска и управления приложениями. Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

> Решение должно соответствовать следующим требованиям:
> 
> * поддержка контейнеров;
> * обеспечивать обнаружение сервисов и маршрутизацию запросов;
> * обеспечивать возможность горизонтального масштабирования;
> * обеспечивать возможность автоматического масштабирования;
> * обеспечивать явное разделение ресурсов, доступных извне и внутри системы;
> * обеспечивать возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т. п.

> 
> Обоснуйте свой выбор.
> 
> ---

### Ответ:

Для обеспечения развертывания, запуска и управления приложениями, которые соответствуют указанным требованиям, я использую следующее решение:

* Kubernetes (K8s)

Kubernetes является популярным и широко используемым инструментом для оркестрации контейнеров. Он обеспечивает поддержку контейнеров и позволяет управлять развертыванием, масштабированием и мониторингом приложений. K8s также предоставляет обнаружение сервисов и маршрутизацию запросов с помощью встроенного в него механизма сервисов и ингресс-контроллеров.

* Docker

Docker является популярным инструментом для контейнеризации приложений. Он позволяет упаковывать приложения и их зависимости в контейнеры, обеспечивая их изолированное выполнение. Kubernetes нативно поддерживает Docker и может использовать его для развертывания и управления контейнеризированными приложениями.

* Kubernetes Horizontal Pod Autoscaler (HPA)

HPA позволяет автоматически масштабировать количество экземпляров приложений на основе текущей нагрузки. Он мониторит метрики, такие как загрузка CPU или использование памяти, и автоматически изменяет количество экземпляров приложений для обеспечения оптимальной производительности.

* Kubernetes Secrets

Kubernetes предоставляет механизм Secrets для безопасного хранения чувствительных данных, таких как пароли, ключи доступа и ключи шифрования. Secrets могут быть использованы в качестве переменных среды в приложениях, обеспечивая возможность конфигурирования приложений с помощью переменных среды.

* Kubernetes ConfigMaps

Кроме Secrets, Kubernetes также предоставляет механизм ConfigMaps для хранения конфигурационных данных в виде переменных среды или файлов. ConfigMaps позволяют конфигурировать приложения с помощью переменных среды и обеспечивают разделение ресурсов доступных извне и внутри системы.

---

Это решение основано на популярных и широко используемых инструментах, которые обеспечивают необходимую функциональность для развертывания, запуска и управления приложениями в микросервисной архитектуре. Kubernetes обеспечивает мощные возможности оркестрации и масштабирования, а Docker позволяет упаковывать и изолировать приложения в контейнеры. Использование HPA позволяет автоматически масштабировать приложения в зависимости от нагрузки.

Secrets и ConfigMaps в Kubernetes обеспечивают безопасное хранение и передачу конфиденциальных данных и конфигурационных параметров в приложениях.

Общая стоимость этого решения может варьироваться в зависимости от масштаба и требований системы.