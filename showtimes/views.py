from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from .models import Movie


def movie_list(request):
    movies = Movie.objects.all()
    return render(request, 'showtimes/movie_list.html', {'movies': movies})


def add_movie(request):
    if request.method == 'POST':
        title = request.POST.get('title', '').strip()
        if title:
            Movie.objects.create(title=title)
            messages.success(request, f'Movie "{title}" added successfully!')
        else:
            messages.error(request, 'Please enter a movie title.')
    return redirect('movie_list')


def vote_movie(request, movie_id):
    if request.method == 'POST':
        movie = get_object_or_404(Movie, id=movie_id)
        movie.vote_count += 1
        movie.save()
        messages.success(request, f'Voted for "{movie.title}"!')
    return redirect('movie_list')
