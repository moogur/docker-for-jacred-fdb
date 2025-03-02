# First stage
FROM alpine AS builder

WORKDIR /app

RUN apk --no-cache --update add bash wget unzip

# Download zip
RUN wget https://github.com/immisterio/jacred-fdb/releases/latest/download/publish.zip
RUN unzip -o publish.zip
RUN rm -f publish.zip

# Download database
RUN wget http://redb.cfhttp.top/latest.zip
RUN unzip -oq latest.zip
RUN rm -f latest.zip

# Second Stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

ENV JACRED_HOME=/home/jacred
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

COPY --from=builder /app $JACRED_HOME/

RUN apk --no-cache --update add icu-libs

WORKDIR $JACRED_HOME

EXPOSE 9117

VOLUME [ "$JACRED_HOME/init.conf", "$JACRED_HOME/Data" ]

ENTRYPOINT ["dotnet", "JacRed.dll"]
