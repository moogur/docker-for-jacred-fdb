### BUILD JACRED MULTIARCH START ###
FROM alpine AS builder

WORKDIR /app

RUN apk --no-cache --update add bash wget unzip
RUN wget https://github.com/immisterio/jacred-fdb/releases/latest/download/publish.zip
RUN unzip -o publish.zip
RUN rm -f publish.zip

### BUILD MAIN IMAGE START ###
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

ENV JACRED_HOME=/home/jacred
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

COPY --from=builder /app $JACRED_HOME/

RUN apk --no-cache --update add icu-libs

WORKDIR $JACRED_HOME

EXPOSE 9117

VOLUME [ "$JACRED_HOME/init.conf", "$JACRED_HOME/Data" ]

ENTRYPOINT ["dotnet", "JacRed.dll"]
