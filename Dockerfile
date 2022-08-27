# Creates the docker container for the workshop in Cambridge
# Run the container with the following command:
#   docker run -it --rm -p 8888:8888 miykael/workshop_cambridge

# FROM miykael/nipype_tutorial:latest
FROM scratch
ARG DEBIAN_FRONTEND=noninteractive

#--------------------------------------
# Update system applications for PyMVPA
#--------------------------------------

#USER root

# Install software for PyMVPA
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           swig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#---------------------------------
# Update conda environment 'neuro'
#---------------------------------

#USER neuro

RUN conda install -y -q --name python=2.7 neuro bokeh \
                                     holoviews \
                                     plotly \
                                     dipy \
                                     vtk \
    && sync && conda clean -tipsy && sync \
    && bash -c "source activate neuro \
    && pip install  --no-cache-dir nibabel \
                                   nilearn \
                                   pymvpa2 \
                                   tensorflow \
                                   keras \
                                   vtk" \
    && rm -rf ~/.cache/pip/* \
    && sync


#USER neuro

RUN mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py

WORKDIR /home/neuro

CMD ["jupyter-notebook"]
