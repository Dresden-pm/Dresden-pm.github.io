FROM perl:5.20

RUN cpanm Text::Markdown
RUN cpanm File::Slurp
RUN cpanm File::Find::Rule

COPY . /app/
WORKDIR /app

#CMD [ "perl", "converter.pl", "markdown" ]
