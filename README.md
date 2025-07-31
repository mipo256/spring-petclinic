# Build Spring

Это специальная ветка для доклада на Joker 2025. 

Для сборки со Spring AOT Bean Definitions и Spring Data AOT Repositories сделайте следующее: 

```
mvn clean package -Pprocess-aot 
```

По сути это обычный билд с `process-aot` Maven профилем.

Далее в директории `target/test-classes/org/springframework/samples/petclinic/owner` можно найти AOT репозиторий "under test" - `OwnerRepositoryImpl_Aot.class`. Это сгенерированный AOT репозиторий.

Далее, специально для команды OpenIDE - есть тест, [вот он](./src/test/java/org/springframework/samples/petclinic/owner/OwnerRepositoryTest.java). И дял этого теста есть специальная конфигурация запуска, которая тригерит поднятие Spring AOT контекста, [вот эта конфигурация](./.run/OwnerRepositoryTest.shouldFindConnorKenway.run.xml).  

Если вы запустите данную конфигурацию в рамках OpenIDE пока без дебага, то тест упадёт. **Это нормально**, так и ожидается. Не нормально другое.

Если Вы посмотрите [стектрейс вызовов](./images/stacktrace.png), то увидите, что вызов прошёл через AOT репозиторий. Но если поставить в `OwnerRepositoryImpl_Aot.class` брейкпоинт, то исполнение потока не прерывается на этом брейкпоинте. Это основная проблема.

P.S: Из проекта **_специально_** удалены все тесты, кроме одного, т.к. в Spring Data AOT есть баг, который рефрешит индекс AOT репозиториев в контексте каждого теста, что не правильно. 
